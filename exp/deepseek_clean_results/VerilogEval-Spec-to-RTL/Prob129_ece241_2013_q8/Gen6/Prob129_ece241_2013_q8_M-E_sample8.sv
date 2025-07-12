module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [2:0] pattern_buffer;
    reg [1:0] pointer;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            pattern_buffer <= 3'b000;
            pointer <= 2'b00;
        end else begin
            // Circular buffer implementation
            pattern_buffer[pointer] <= x;
            pointer <= pointer + 1;
        end
    end

    // Mealy output: check if current window matches "101"
    // Note: We need to check all possible rotations due to circular nature
    assign z = ((pattern_buffer == 3'b101) ||  // Normal case
               ((pattern_buffer[1:0] == 2'b10) && (pointer == 2'b10) && x) ||  // Partial wrap
               ((pattern_buffer[2] == 1'b1) && (pointer == 2'b01) && (x == 1'b0));  // Full wrap case

endmodule