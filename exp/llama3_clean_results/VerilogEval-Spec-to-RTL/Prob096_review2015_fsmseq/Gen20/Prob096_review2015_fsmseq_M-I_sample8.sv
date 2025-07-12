module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] state;
reg [3:0] next_state;
reg start_shifting_next;

always_comb begin
    start_shifting_next = start_shifting;
    case(state)
        4'b0000: next_state = data? 4'b0001 : 4'b0000;
        4'b0001: next_state = data? 4'b0011 : 4'b0000;
        4'b0011: next_state = ~data? 4'b0110 : 4'b0011;
        4'b0110: begin
            if(data) begin
                next_state = 4'b1101;
                start_shifting_next = 1'b1;
            end else begin
                next_state = 4'b0000;
            end
        end
        4'b1101: next_state = 4'b1101;
        default: next_state = 4'b0000;
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 4'b0000;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        start_shifting <= start_shifting_next;
    end
end

endmodule