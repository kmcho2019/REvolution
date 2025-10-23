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
    reg [23:0] next_out_bytes;

    // Combinational done signal
    assign done = (state == BYTE2);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'bx;
        end else begin
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        next_out_bytes[23:16] <= in;
                        state <= BYTE1;
                    end
                end
                
                BYTE1: begin
                    next_out_bytes[15:8] <= in;
                    state <= BYTE2;
                end
                
                BYTE2: begin
                    next_out_bytes[7:0] <= in;
                    out_bytes <= next_out_bytes;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    // Update output registers only when needed
    always @(*) begin
        case (state)
            BYTE1: out_bytes = {next_out_bytes[23:16], 16'bx};
            BYTE2: out_bytes = {next_out_bytes[23:8], 8'bx};
            default: out_bytes = 24'bx;
        endcase
    end

endmodule