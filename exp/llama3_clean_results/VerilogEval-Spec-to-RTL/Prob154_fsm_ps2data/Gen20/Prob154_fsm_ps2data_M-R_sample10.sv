module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [2:0] state; // One-hot encoding: 1'b001 for idle, 1'b010 for byte1, 1'b100 for byte2
reg [2:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b001; // Reset to idle state
        out_bytes <= 0;
    end else begin
        state <= next_state;
        case (state)
            3'b001: begin // Idle state
                if (in[3] == 1'b1) begin
                    out_bytes[23:16] <= in;
                end
            end
            3'b010: begin // Byte1 state
                out_bytes[15:8] <= in;
            end
            3'b100: begin // Byte2 state
                out_bytes[7:0] <= in;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        3'b001: begin
            if (in[3] == 1'b1) begin
                next_state = 3'b010;
            end else begin
                next_state = 3'b001;
            end
            done = 1'b0;
        end
        3'b010: begin
            next_state = 3'b100;
            done = 1'b0;
        end
        3'b100: begin
            next_state = 3'b001;
            done = 1'b1;
        end
        default: begin
            next_state = 3'b001;
            done = 1'b0;
        end
    endcase
end

endmodule