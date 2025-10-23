module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] state, next_state;
reg [9:0] accumulator, next_accumulator;
wire [9:0] sum = accumulator + data_in;

// State machine and accumulator update
always @(*) begin
    next_state = state;
    next_accumulator = accumulator;
    valid_out = 1'b0;
    
    if (valid_in) begin
        next_accumulator = sum;
        next_state = state + 1'b1;
        
        if (state == 2'b11) begin
            next_accumulator = 10'b0;
            next_state = 2'b0;
            valid_out = 1'b1;
        end
    end
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b0;
        accumulator <= 10'b0;
        data_out <= 10'b0;
    end
    else begin
        state <= next_state;
        accumulator <= next_accumulator;
        if (valid_out) begin
            data_out <= sum;
        end
    end
end

endmodule