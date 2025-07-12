module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

// Define states
enum logic [1:0] {Idle, Byte1, Byte2, Done} state, next_state;

// Define internal signals
logic [23:0] message;
logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        message <= 24'b0;
        byte_count <= 2'b0;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            Idle: begin
                if (in[3] == 1'b1) begin
                    message[7:0] <= in;
                    state <= Byte1;
                    byte_count <= 2'b1;
                end
            end
            Byte1: begin
                message[15:8] <= in;
                state <= Byte2;
                byte_count <= 2'b2;
            end
            Byte2: begin
                message[23:16] <= in;
                state <= Done;
            end
            Done: begin
                state <= Idle;
            end
        endcase
        if (state == Done) begin
            out_bytes <= message;
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
    end
end

endmodule