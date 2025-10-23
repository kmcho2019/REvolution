module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg state;
reg [1:0] counter;
reg w_count;

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0;
        counter <= 2'b00;
        w_count <= 1'b0;
        z <= 1'b0;
    end else begin
        case(state)
            1'b0: begin
                if(s) begin
                    state <= 1'b1;
                    counter <= 2'b01;
                    w_count <= 1'b0;
                end
            end
            1'b1: begin
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
                counter <= counter + 1'b1;
                if(counter == 2'b11) begin
                    if(w_count == 2'b10) begin
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    state <= 1'b1;
                    counter <= 2'b01;
                    w_count <= 1'b0;
                end
            end
        endcase
    end
end

endmodule