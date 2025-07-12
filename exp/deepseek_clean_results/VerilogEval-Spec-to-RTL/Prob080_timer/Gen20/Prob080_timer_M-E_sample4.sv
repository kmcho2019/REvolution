module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg [9:0] next_counter;
    wire any_bit_set = |counter;  // Priority-encoded zero detection
    
    always @(*) begin
        if (load) begin
            next_counter = data;
        end else if (any_bit_set) begin
            next_counter = counter - 1'b1;
        end else begin
            next_counter = 10'b0;
        end
    end

    always @(posedge clk) begin
        counter <= next_counter;
    end

    assign tc = ~any_bit_set;  // Inverted for faster detection

endmodule