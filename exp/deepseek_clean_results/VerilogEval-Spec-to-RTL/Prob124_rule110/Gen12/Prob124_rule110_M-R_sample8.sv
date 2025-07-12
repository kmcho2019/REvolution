module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Extended version of q with boundary conditions
    wire [513:0] extended_q = {1'b0, q, 1'b0};

    // Next state calculation
    wire [511:0] next_q;
    
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Neighbor selection from extended_q
            wire [2:0] neighbors = extended_q[i+2:i];
            
            // Rule 110 implementation using case statement equivalent
            assign next_q[i] = (neighbors == 3'b110) ||  // 110 -> 1
                               (neighbors == 3'b101) ||  // 101 -> 1
                               (neighbors == 3'b011) ||  // 011 -> 1
                               (neighbors == 3'b010) ||  // 010 -> 1
                               (neighbors == 3'b001) ||  // 001 -> 1
                               (neighbors == 3'b000);    // 000 -> 0
            // All other cases (111 and 100) result in 0
        end
    endgenerate

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    // Initialization for simulation
    initial begin
        q = 512'b0;
    end

endmodule