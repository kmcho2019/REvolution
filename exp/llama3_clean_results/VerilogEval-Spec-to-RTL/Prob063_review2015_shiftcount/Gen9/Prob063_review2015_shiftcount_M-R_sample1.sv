module TopModule (
    input clk,
    input reset,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] counter;
wire [3:0] next_state;

assign next_state = shift_ena ? {data, counter[3:1]} : 
                    count_ena ? (counter > 0 ? counter - 1 : 0) : counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 4'b0000;
    end else begin
        counter <= next_state;
    end
end

assign q = counter;

endmodule