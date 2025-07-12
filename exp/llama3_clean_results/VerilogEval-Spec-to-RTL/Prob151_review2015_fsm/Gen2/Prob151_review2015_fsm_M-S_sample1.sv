module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [2:0] state;
reg [1:0] shift_count;
reg [3:0] pattern;

localparam IDLE = 3'b000;
localparam SHIFT = 3'b001;
localparam COUNTING = 3'b010;
localparam DONE = 3'b011;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 2'b00;
        pattern <= 4'b0000;
    end else begin
        case (state)
            IDLE: begin
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_count <= 2'b00;
                end
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFT: begin
                shift_count <= shift_count + 1'b1;
                shift_ena <= 1'b1;
                if (shift_count == 2'b11) begin
                    state <= COUNTING;
                end
                counting <= 1'b0;
                done <= 1'b0;
            end
            COUNTING: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                if (done_counting) begin
                    state <= DONE;
                end
                done <= 1'b0;
            end
            DONE: begin
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b1;
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule