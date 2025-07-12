module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    reg [7:0] data_reg;
    reg [1:0] reset_counter;
    reg test_mode;
    
    // Shift mode activation logic
    always @(posedge clk) begin
        if (reset) begin
            if (reset_counter == 2'd2) test_mode <= 1'b1;
            reset_counter <= reset_counter + 1;
        end else begin
            test_mode <= 1'b0;
            reset_counter <= 2'd0;
        end
    end
    
    // Main register with parallel load/shift capability
    always @(posedge clk) begin
        if (reset && !test_mode) begin
            data_reg <= 8'h00;  // Normal reset
        end else if (test_mode) begin
            data_reg <= {data_reg[6:0], data_reg[7]};  // Circular shift
        end else begin
            data_reg <= d;  // Parallel load
        end
    end
    
    assign q = data_reg;
    
    // Built-in assertion for reset timing
    property reset_timing;
        @(posedge clk) reset |-> ##2 reset;
    endproperty
    
    assert property (reset_timing) else $warning("Reset held for insufficient time for test mode");
    
endmodule