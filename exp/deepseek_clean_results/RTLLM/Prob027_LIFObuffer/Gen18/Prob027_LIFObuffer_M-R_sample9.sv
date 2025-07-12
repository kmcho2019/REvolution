module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    // Stack memory (4 entries of 4 bits)
    reg [3:0] stack_mem [0:3];
    // State encoding: 3 bits [0-4] representing stack level
    reg [2:0] state;

    // Combinational assignments
    assign EMPTY = (state == 3'b000);
    assign FULL = (state == 3'b100);

    // Stack memory access (combinational)
    wire [3:0] top_value = stack_mem[state-1];

    // State update logic
    always @(posedge Clk) begin
        if (Rst) begin
            state <= 3'b000;
        end
        else if (EN) begin
            // Push operation
            if (!RW && !FULL) begin
                stack_mem[state] <= dataIn;
                state <= state + 1;
            end
            // Pop operation
            else if (RW && !EMPTY) begin
                state <= state - 1;
            end
        end
    end

    // Output register update
    always @(posedge Clk) begin
        if (Rst) begin
            dataOut <= 4'b0;
        end
        else if (EN && RW && !EMPTY) begin
            dataOut <= top_value;
        end
    end

endmodule