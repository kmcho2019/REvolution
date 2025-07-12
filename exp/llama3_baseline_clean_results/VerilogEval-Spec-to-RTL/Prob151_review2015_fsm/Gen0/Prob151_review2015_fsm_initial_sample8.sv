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

reg [3:0] state;
reg [3:0] shift_reg;
reg [3:0] count;

// Define states
localparam IDLE = 4'd0;
localparam SHIFT = 4'd1;
localparam COUNT = 4'd2;
localparam DONE = 4'd3;

// Define outputs based on states
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == DONE);

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_reg <= 4'd0;
        count <= 4'd0;
    end
    else begin
        case (state)
            IDLE: begin
                shift_reg <= {data, shift_reg[3:1]};
                if (shift_reg == 4'b1101) begin
                    state <= SHIFT;
                    count <= 4'd0;
                end
            end
            SHIFT: begin
                count <= count + 1;
                if (count == 4'd4) begin
                    state <= COUNT;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule