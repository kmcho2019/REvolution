module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] counter;
reg [1:0] w_count;
reg in_state_b;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        counter <= 2'b00;
        w_count <= 2'b00;
        z <= 1'b0;
        in_state_b <= 1'b0;
    end else begin
        if(s && !in_state_b) begin
            in_state_b <= 1'b1;
            counter <= 2'b01;
            w_count <= 2'b00;
        end else if(in_state_b) begin
            if(counter < 2'b11) begin
                counter <= counter + 1;
                if(w) begin
                    w_count <= w_count + 1;
                end
            end else begin
                z <= (w_count == 2'b10) ? 1'b1 : 1'b0;
                counter <= 2'b01;
                w_count <= 2'b00;
            end
        end
    end
end

endmodule