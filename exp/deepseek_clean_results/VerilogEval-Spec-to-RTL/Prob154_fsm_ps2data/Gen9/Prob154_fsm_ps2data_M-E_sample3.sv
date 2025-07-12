module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // One-hot state encoding
    localparam [2:0] IDLE  = 3'b001;
    localparam [2:0] BYTE1 = 3'b010;
    localparam [2:0] BYTE2 = 3'b100;

    reg [2:0] state;
    reg [23:0] shift_reg;
    wire next_done;

    // Combinational done calculation
    assign next_done = (state == BYTE2);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 24'bx; // Don't-care during reset
            done <= 1'b0;
        end else begin
            done <= next_done;

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        shift_reg <= {in, 16'bx}; // Store first byte, others don't-care
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    shift_reg <= {shift_reg[23:16], in, 8'bx}; // Shift in second byte
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    shift_reg <= {shift_reg[23:8], in}; // Shift in third byte
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    // Output is valid only when done is asserted
    always @(*) begin
        if (done)
            out_bytes = shift_reg;
        else
            out_bytes = 24'bx;
    end

endmodule