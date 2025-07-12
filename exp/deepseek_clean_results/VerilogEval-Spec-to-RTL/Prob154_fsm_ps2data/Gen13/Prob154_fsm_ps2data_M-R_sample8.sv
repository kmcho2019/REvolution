module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    // One-hot state encoding
    localparam IDLE = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;
    
    reg [2:0] state, next_state;
    reg [23:0] next_out_bytes;
    wire byte_valid = in[3];

    // State transition logic
    always @(*) begin
        next_state = IDLE;
        next_out_bytes = out_bytes;
        
        case (state)
            IDLE: begin
                if (byte_valid) begin
                    next_state = BYTE1;
                    next_out_bytes = {in, 16'b0};
                end else begin
                    next_state = IDLE;
                end
            end
            BYTE1: begin
                next_state = BYTE2;
                next_out_bytes = {out_bytes[23:16], in, 8'b0};
            end
            BYTE2: begin
                next_state = IDLE;
                next_out_bytes = {out_bytes[23:8], in};
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            out_bytes <= 24'b0;
        end else begin
            state <= next_state;
            out_bytes <= next_out_bytes;
        end
    end

    // Combinational output
    assign done = (state == BYTE2);

endmodule