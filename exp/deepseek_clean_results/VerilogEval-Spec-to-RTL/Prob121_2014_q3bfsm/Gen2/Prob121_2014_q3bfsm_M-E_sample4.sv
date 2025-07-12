module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // State register
    reg [2:0] state;

    // Combined next state and output
    reg [3:0] rom_out; // [3] = z, [2:0] = next_state

    always @(*) begin
        case ({state, x})
            4'b0000: rom_out = 4'b0000; // state 000, x=0
            4'b0001: rom_out = 4'b0001; // state 000, x=1
            4'b0010: rom_out = 4'b0001; // state 001, x=0
            4'b0011: rom_out = 4'b0100; // state 001, x=1
            4'b0100: rom_out = 4'b0010; // state 010, x=0
            4'b0101: rom_out = 4'b0001; // state 010, x=1
            4'b0110: rom_out = 4'b1001; // state 011, x=0
            4'b0111: rom_out = 4'b0010; // state 011, x=1
            4'b1000: rom_out = 4'b1011; // state 100, x=0
            4'b1001: rom_out = 4'b1100; // state 100, x=1
            default: rom_out = 4'b0000;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z <= 1'b0;
        end
        else begin
            state <= rom_out[2:0];
            z <= rom_out[3];
        end
    end

endmodule