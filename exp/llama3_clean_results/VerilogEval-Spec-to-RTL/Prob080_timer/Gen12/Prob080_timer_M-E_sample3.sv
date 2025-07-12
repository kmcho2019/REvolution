module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

reg [9:0] counter;
reg [1:0] state; // One-hot encoding for states: Idle (2'b01), Counting (2'b10)
wire [1:0] next_state;

always @(posedge clk)
    case(state)
        2'b01: // Idle
            if (load)
                begin
                    counter <= data;
                    state <= 2'b10;
                end
            else
                state <= 2'b01;
        2'b10: // Counting
            if (counter != 10'd0)
                begin
                    counter <= counter - 1;
                    state <= 2'b10;
                end
            else
                state <= 2'b10;
        default:
            state <= 2'b01; // Reset to Idle state
    endcase

assign tc = (state == 2'b10 && counter == 10'd0);

endmodule