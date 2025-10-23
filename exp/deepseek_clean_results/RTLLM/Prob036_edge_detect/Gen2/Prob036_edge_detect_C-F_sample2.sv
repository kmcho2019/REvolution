module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg a_prev;
wire changed = (a != a_prev);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_prev <= 1'b0;
        {rise, down} <= 2'b00;
    end
    else begin
        a_prev <= a;
        
        if (changed) begin
            case ({a_prev, a})
                2'b01: {rise, down} <= 2'b10;  // Rising edge
                2'b10: {rise, down} <= 2'b01;  // Falling edge
                default: {rise, down} <= 2'b00;
            endcase
        end
        else begin
            {rise, down} <= 2'b00;
        end
    end
end

endmodule