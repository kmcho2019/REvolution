module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Configuration: 0 for zero boundaries, 1 for circular
    parameter BOUNDARY_MODE = 0;
    
    // Pipeline registers
    reg [511:0] left_neighbors;
    reg [511:0] right_neighbors;
    reg [511:0] current_state;
    
    // Next state calculation
    wire [511:0] next_q;
    
    // Calculate neighbors with boundary handling
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
            if (BOUNDARY_MODE) begin
                // Circular boundaries
                left_neighbors <= {data[0], data[511:1]};
                right_neighbors <= {data[510:0], data[511]};
            end else begin
                // Zero boundaries
                left_neighbors <= {1'b0, data[511:1]};
                right_neighbors <= {data[510:0], 1'b0};
            end
        end else begin
            current_state <= q;
            if (BOUNDARY_MODE) begin
                // Circular boundaries
                left_neighbors <= {q[0], q[511:1]};
                right_neighbors <= {q[510:0], q[511]};
            end else begin
                // Zero boundaries
                left_neighbors <= {1'b0, q[511:1]};
                right_neighbors <= {q[510:0], 1'b0};
            end
        end
    end
    
    // Optimized Rule 110 calculation using bitwise operations
    assign next_q = (current_state ^ right_neighbors) | 
                   (~left_neighbors & (current_state | right_neighbors));
    
    // State update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule