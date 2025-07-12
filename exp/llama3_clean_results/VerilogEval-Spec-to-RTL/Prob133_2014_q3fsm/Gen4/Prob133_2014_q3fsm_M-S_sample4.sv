module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] counter; // counter to track 'w' = 1
reg [2:0] timer; // timer to track 3 clock cycles
reg in_state_b; // flag to indicate if we are in state B

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 2'b00;
        timer <= 3'b000;
        in_state_b <= 0;
        z <= 0;
    end
    else begin
        if (~in_state_b && s) begin // transition from A to B
            in_state_b <= 1;
            timer <= 3'b001;
        end
        else if (in_state_b) begin
            if (timer < 3'b111) begin
                timer <= timer + 3'b001;
                if (w) begin
                    counter <= counter + 1'b1;
                end
            end
            else begin
                if (counter == 2) begin
                    z <= 1;
                end
                else begin
                    z <= 0;
                end
                timer <= 3'b001;
                counter <= 2'b00;
            end
        end
    end
end

endmodule