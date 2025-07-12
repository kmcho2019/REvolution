module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] next_counter;
    wire counter_enable;

    // Enable counter only when not zero or loading
    assign counter_enable = (counter != 0) || load;

    // Next state logic (combinational)
    assign next_counter = load ? data : 
                        (counter - 1);

    // Sequential logic with explicit clock gating
    always @(posedge clk) begin
        if (counter_enable) begin
            counter <= next_counter;
        end
    end

    // Output logic
    assign tc = (counter == 0);

endmodule