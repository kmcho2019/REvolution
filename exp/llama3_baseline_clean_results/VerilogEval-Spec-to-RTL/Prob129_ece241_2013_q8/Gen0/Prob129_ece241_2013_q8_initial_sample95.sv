module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

always @(*)
begin
    case (state)
        2'b00: // S0
        begin
            if (x)
                next_state = 2'b01; // S1
            else
                next_state = 2'b00; // S0
        end
        2'b01: // S1
        begin
            if (!x)
                next_state = 2'b10; // S2
            else
                next_state = 2'b01; // S1
        end
        2'b10: // S2
        begin
            if (x)
                next_state = 2'b00; // S0 (sequence "101" detected)
            else
                next_state = 2'b00; // S0
        end
    endcase
end

always @(posedge clk or negedge aresetn)
begin
    if (!aresetn)
        state <= 2'b00; // S0
    else
        state <= next_state;
end

always @(*)
begin
    if (state == 2'b10 && x) // S2 and x is "1"
        z = 1'b1;
    else
        z = 1'b0;
end

endmodule