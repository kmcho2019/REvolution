module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: state A, 1: state B
reg [1:0] w_count; // count of high w signals
reg [1:0] cycle_count; // clock cycle counter since entering state B

always @(posedge clk) begin
    if(reset) begin
        state <= 1'b0;
        w_count <= 2'b00;
        cycle_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            1'b0: begin // state A
                if(s) begin
                    state <= 1'b1;
                    w_count <= 2'b00;
                    cycle_count <= 2'b01;
                end
            end
            1'b1: begin // state B
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
                cycle_count <= cycle_count + 1'b1;
                if(cycle_count == 3) begin
                    cycle_count <= 2'b01;
                    if(w_count == 2'b10) begin
                        z <= 1'b1;
                    end else begin
                        z <= 1'b0;
                    end
                    w_count <= 2'b00;
                end
            end
            default: ;
        endcase
    end
end

endmodule