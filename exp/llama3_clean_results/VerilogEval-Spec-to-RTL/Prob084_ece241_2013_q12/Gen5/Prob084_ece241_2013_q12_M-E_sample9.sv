module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    reg [7:0] memory;
    reg [2:0] counter;

    // Ring counter
    always @(posedge clk) begin
        if (enable) begin
            counter <= counter + 1;
            if (counter == 7) begin
                counter <= 0;
            end
            memory[counter] <= S;
        end
    end

    // Output assignment
    always @(*) begin
        Z = memory[{A, B, C}];
    end

endmodule