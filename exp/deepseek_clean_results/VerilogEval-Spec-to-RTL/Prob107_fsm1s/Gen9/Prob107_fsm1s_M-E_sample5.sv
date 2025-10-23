module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding (1-bit for 2 states)
    reg state;  // 0=B, 1=A
    
    // ROM output signals
    wire next_state;
    wire rom_out;
    
    // Combined ROM for state transitions and output
    always @(*) begin
        case ({state, in})
            2'b00: {next_state, rom_out} = 2'b11; // B, in=0 → A (out=1)
            2'b01: {next_state, rom_out} = 2'b01; // B, in=1 → B (out=1)
            2'b10: {next_state, rom_out} = 2'b00; // A, in=0 → B (out=0)
            2'b11: {next_state, rom_out} = 2'b10; // A, in=1 → A (out=0)
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;  // Reset to state B
        else
            state <= next_state;
    end

    // Output assignment
    assign out = rom_out;

endmodule