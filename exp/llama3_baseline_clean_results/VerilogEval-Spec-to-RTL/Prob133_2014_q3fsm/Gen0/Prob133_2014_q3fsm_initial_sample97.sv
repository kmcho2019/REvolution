module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state;
reg [1:0] count;  // counter for clock cycles
reg [1:0] w_count;  // counter for w = 1
reg temp_z;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b01;  // initial state A
        count <= 2'b00;
        w_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case (state)
            2'b01: begin  // state A
                if (s) begin
                    state <= 2'b10;  // move to state B
                end
                z <= 1'b0;
            end
            2'b10: begin  // state B
                count <= count + 1'b1;
                if (w) begin
                    w_count <= w_count + 1'b1;
                end
                if (count == 3) begin
                    if (w_count == 2) begin
                        temp_z <= 1'b1;
                    end else begin
                        temp_z <= 1'b0;
                    end
                    count <= 2'b00;
                    w_count <= 2'b00;
                end
            end
        endcase
        z <= temp_z;
    end
end

endmodule