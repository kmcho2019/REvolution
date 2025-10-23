module TopModule (
    input clk,
    input x,
    output reg z
);

    reg [1:0] counter = 2'b00;  // 3-state counter (0,1,2)
    reg dff = 1'b0;             // Single shared D flip-flop
    reg [2:0] results = 3'b000; // Storage for all three gate results
    
    wire gate_out;
    
    // Gate selection based on counter
    assign gate_out = (counter == 2'b00) ? (x ^ dff) :        // XOR
                     (counter == 2'b01) ? (x & ~dff) :        // AND
                     (x | ~dff);                             // OR
    
    // Update state on positive clock edge
    always @(posedge clk) begin
        dff <= gate_out;
        
        // Store result when each gate is processed
        if (counter == 2'b00) results[2] <= dff;
        if (counter == 2'b01) results[1] <= dff;
        if (counter == 2'b10) results[0] <= dff;
        
        // Update counter
        counter <= (counter == 2'b10) ? 2'b00 : counter + 1;
        
        // Update output when all results are ready
        if (counter == 2'b10) z <= ~(|results);
    end

endmodule