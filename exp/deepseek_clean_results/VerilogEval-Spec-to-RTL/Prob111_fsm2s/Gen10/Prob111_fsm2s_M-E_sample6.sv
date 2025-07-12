module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // One-hot encoding (though only 2 states needed)
    localparam OFF = 2'b01;
    localparam ON  = 2'b10;
    
    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end
        else begin
            case (state)
                OFF: state <= j ? ON : OFF;
                ON:  state <= k ? OFF : ON;
                default: state <= OFF;
            endcase
        end
    end

    assign out = state[1];  // ON state bit is the output

endmodule