module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define the states
localparam IDLE = 2'b00;
localparam SHIFT = 2'b01;
localparam COUNT = 2'b10;
localparam DONE = 2'b11;

reg [1:0] state;
reg [3:0] pattern;
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
        counting <= 1'b0;
        done <= 1'b0;
        shift_ena <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_count <= 2'b00;
                    shift_ena <= 1'b1;
                end
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                if (shift_count == 2'b11) begin
                    state <= COUNT;
                    counting <= 1'b1;
                    shift_ena <= 1'b0;
                end else begin
                    shift_count <= shift_count + 1'b1;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= DONE;
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule