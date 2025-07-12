module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    reg [9:0] preload;
    reg state; // 0: IDLE, 1: COUNTING

    always @(posedge clk) begin
        if (load) begin
            preload <= data;
            counter <= data;
            state <= 1'b1; // Enter COUNTING state
        end
        else if (state) begin // In COUNTING state
            if (counter != 0)
                counter <= counter - 1;
            else
                state <= 1'b0; // Return to IDLE state
        end
    end

    assign tc = (state == 1'b0); // Terminal count when in IDLE state

endmodule