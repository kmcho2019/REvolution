module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state;
reg [1:0] counter_3;
reg counter_w;
reg set_z;

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // State A
        counter_3 <= 2'b00;
        counter_w <= 1'b0;
        set_z <= 1'b0;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // State A
                if(s) begin
                    state <= 2'b01; // State B
                end
                counter_3 <= 2'b00;
                counter_w <= 1'b0;
                set_z <= 1'b0;
                z <= 1'b0;
            end
            2'b01: begin // State B
                if(counter_3 == 2'b11) begin // End of 3 clock cycles
                    if(counter_w == 2'b10) begin // w = 1 exactly twice
                        set_z <= 1'b1;
                    end
                    counter_3 <= 2'b00;
                    counter_w <= 1'b0;
                end else begin
                    if(w) begin
                        counter_w <= counter_w + 1'b1;
                    end
                    counter_3 <= counter_3 + 1'b1;
                end
                if(set_z) begin
                    z <= 1'b1;
                    set_z <= 1'b0;
                end else begin
                    z <= 1'b0;
                end
            end
            default: begin
                state <= 2'b00; // Reset to State A
                counter_3 <= 2'b00;
                counter_w <= 1'b0;
                set_z <= 1'b0;
                z <= 1'b0;
            end
        endcase
    end
end

endmodule