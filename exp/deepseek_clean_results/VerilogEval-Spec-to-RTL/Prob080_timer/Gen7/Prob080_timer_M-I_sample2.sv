module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [4:0] upper = counter[9:5];
    wire [4:0] lower = counter[4:0];
    wire upper_zero = ~|upper;
    wire lower_zero = ~|lower;
    
    // Carry-select style decrementer
    wire [4:0] lower_next = lower - 1'b1;
    wire [4:0] upper_next = upper_zero ? upper : (upper - 1'b1);
    
    // Clock gating logic
    wire counter_active = load | (|counter);
    
    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end
        else if (counter_active) begin
            counter <= {upper_next, lower_next};
        end
    end

    // Hierarchical zero detection
    assign tc = upper_zero & lower_zero;

endmodule