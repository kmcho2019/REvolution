module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state;
reg [2:0] w_count;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00;
        w_count <= 3'b000;
    end else begin
        case(state)
            2'b00: begin
                if(s) begin
                    state <= 2'b01;
                    w_count <= 3'b001;
                end else begin
                    state <= 2'b00;
                    w_count <= 3'b000;
                end
            end
            2'b01: begin
                w_count <= {w_count[1:0], w};
                if(w_count == 3'b110 || w_count == 3'b101 || w_count == 3'b011) begin
                    state <= 2'b10;
                end else begin
                    state <= 2'b01;
                end
            end
            2'b10: begin
                z <= 1'b1;
                state <= 2'b01;
            end
            default: state <= 2'b00;
        endcase
    end
end

always @(posedge clk) begin
    if(state != 2'b10) begin
        z <= 1'b0;
    end
end

endmodule