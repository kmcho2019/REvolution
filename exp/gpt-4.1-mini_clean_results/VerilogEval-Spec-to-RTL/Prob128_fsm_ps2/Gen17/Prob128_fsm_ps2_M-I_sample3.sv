module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);
    // FSM states
    localparam IDLE = 1'b0;
    localparam RECEIVING = 1'b1;

    reg state;
    reg [1:0] count;

    wire start_byte = in[3];

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default

            case(state)
                IDLE: begin
                    count <= 2'd0;
                    if (start_byte) begin
                        state <= RECEIVING;
                        count <= 2'd1; // first byte received
                    end
                end
                RECEIVING: begin
                    if (count == 2'd3) begin
                        // After 3 bytes, signal done and return to IDLE
                        done <= 1'b1;
                        state <= IDLE;
                        count <= 2'd0;
                    end else begin
                        // Count bytes
                        count <= count + 1'b1;
                    end
                end
            endcase
        end
    end

endmodule