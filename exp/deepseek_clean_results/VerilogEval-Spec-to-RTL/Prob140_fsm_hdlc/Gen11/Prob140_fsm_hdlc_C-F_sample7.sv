module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // Counter tracks consecutive 1s (0-7)
    reg [2:0] count;
    
    // Combinational next state and outputs
    wire [2:0] next_count;
    wire next_disc, next_flag, next_err;
    
    // State transition logic
    assign next_count = reset ? 3'b0 : 
                      (in && (count < 7)) ? count + 1 : 
                      (in ? count : 3'b0);
    
    // Output logic (assert next cycle)
    assign next_disc = (count == 5) && !in;
    assign next_flag = (count == 6) && !in;
    assign next_err = (count >= 6) && in;
    
    // Sequential logic
    always @(posedge clk) begin
        count <= next_count;
        disc <= next_disc;
        flag <= next_flag;
        err <= next_err;
    end

endmodule