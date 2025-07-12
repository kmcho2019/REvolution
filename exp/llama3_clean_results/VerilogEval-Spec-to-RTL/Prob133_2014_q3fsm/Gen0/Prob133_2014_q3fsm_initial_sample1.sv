module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state;
reg [2:0] count;
reg [1:0] counter;

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // State A
        count <= 3'b000;
        counter <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // Transition to State B
                    counter <= 2'b01;
                end
            end
            2'b01: begin // State B
                if(counter == 2'b11) begin
                    if(count == 3'b010) begin
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    state <= 2'b01;
                    counter <= 2'b01;
                    count <= 3'b000;
                end else begin
                    if(w) begin
                        count <= count + 1'b1;
                    end
                    counter <= counter + 1'b1;
                end
            end
        endcase
    end
end

endmodule