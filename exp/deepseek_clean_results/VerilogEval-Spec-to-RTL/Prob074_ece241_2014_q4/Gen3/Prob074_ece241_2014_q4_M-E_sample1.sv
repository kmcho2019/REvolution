module TopModule (
    input clk,
    input x,
    output z
);

    // Operation counter (0: XOR, 1: AND, 2: OR)
    reg [1:0] counter = 2'b0;
    
    // Shared flip-flop for intermediate results
    reg shared_ff = 1'b0;
    
    // Pipeline register for final results
    reg [2:0] pipeline = 3'b0;
    
    // Combinational logic for all operations
    wire xor_result = x ^ shared_ff;
    wire and_result = x & ~shared_ff;
    wire or_result  = x | ~shared_ff;
    
    // Next operation result
    wire next_result;
    assign next_result = (counter == 2'b00) ? xor_result :
                        (counter == 2'b01) ? and_result :
                        or_result;
    
    // Update logic
    always @(posedge clk) begin
        // Update shared flip-flop
        shared_ff <= next_result;
        
        // Update pipeline (shift left and insert new result)
        pipeline <= {pipeline[1:0], next_result};
        
        // Increment counter
        counter <= counter + 1;
    end
    
    // Output is NOR of pipeline
    assign z = ~(|pipeline);

endmodule