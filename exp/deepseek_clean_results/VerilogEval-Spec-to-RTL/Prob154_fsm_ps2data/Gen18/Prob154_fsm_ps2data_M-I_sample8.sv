module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // One-hot state encoding
    localparam [2:0] IDLE  = 3'b001;
    localparam [2:0] BYTE1 = 3'b010;
    localparam [2:0] BYTE2 = 3'b100;

    reg [2:0] state;
    reg [7:0] in_reg;  // Registered input to improve timing

    // Combinational done signal
    assign done = (state == BYTE2);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'bx; // Don't-care during reset
            in_reg <= 8'b0;
        end else begin
            // Register input to break timing path
            in_reg <= in;

            case (state)
                IDLE: begin
                    if (in_reg[3]) begin
                        out_bytes[23:16] <= in_reg; // Store first byte
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    out_bytes[15:8] <= in_reg; // Store second byte
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    out_bytes[7:0] <= in_reg; // Store third byte
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule