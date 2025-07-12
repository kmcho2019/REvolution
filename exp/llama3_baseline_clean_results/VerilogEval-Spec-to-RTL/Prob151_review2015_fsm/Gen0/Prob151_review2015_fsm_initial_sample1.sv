module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] state;
reg [3:0] count;
reg [3:0] pattern;

always @(posedge clk) begin
    if(reset) begin
        state <= 4'b0000; // IDLE state
        count <= 4'b0000;
        pattern <= 4'b0000;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end
    else begin
        case(state)
            4'b0000: begin // IDLE state
                pattern <= {pattern[2:0], data};
                if(pattern == 4'b1101) begin
                    state <= 4'b0001; // SHIFT state
                    count <= 4'b1000; // Initialize counter to 4
                end
                else begin
                    state <= 4'b0000;
                end
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            4'b0001: begin // SHIFT state
                shift_ena <= 1'b1;
                count <= count - 1'b1;
                if(count == 4'b0000) begin
                    state <= 4'b0010; // COUNTING state
                end
            end
            4'b0010: begin // COUNTING state
                counting <= 1'b1;
                shift_ena <= 1'b0;
                if(done_counting) begin
                    state <= 4'b0011; // DONE state
                end
            end
            4'b0011: begin // DONE state
                done <= 1'b1;
                counting <= 1'b0;
                if(ack) begin
                    state <= 4'b0000; // IDLE state
                end
            end
            default: begin
                state <= 4'b0000;
            end
        endcase
    end
end

endmodule