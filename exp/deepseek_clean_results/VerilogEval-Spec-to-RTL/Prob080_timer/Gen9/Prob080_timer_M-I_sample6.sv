module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire counter_enable = ~tc;  // Only enable counting when not at zero

    always @(posedge clk) begin
        case ({load, counter_enable})
            2'b10: counter <= data;         // Load new value
            2'b01: counter <= counter - 1;  // Decrement when enabled
            2'b11: counter <= data;         // Load has priority
            default: counter <= counter;    // Hold when disabled
        endcase
    end

    assign tc = (counter == 0);

endmodule