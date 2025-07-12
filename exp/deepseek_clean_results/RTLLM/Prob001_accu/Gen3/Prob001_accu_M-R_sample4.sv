module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

    parameter GROUP_SIZE = 4;
    
    reg [1:0] state;  // 0-3 counting states
    reg [9:0] accum;  // Accumulator register
    
    // State machine and accumulation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 0;
            accum <= 0;
        end
        else if (valid_in) begin
            if (state == GROUP_SIZE-1) begin
                state <= 0;
                accum <= 0;  // Reset for next group
            end
            else begin
                state <= state + 1;
                accum <= accum + data_in;
            end
        end
    end
    
    // Output logic
    assign valid_out = (state == GROUP_SIZE-1) && valid_in;
    assign data_out = accum + (valid_in ? data_in : 0);  // Final addition
    
endmodule