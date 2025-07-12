module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state;
reg [2:0] w_seq;
reg w_count;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 2'b00;
        w_seq <= 3'b000;
        w_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            2'b00: begin
                if(s) begin
                    state <= 2'b01;
                    w_seq <= 3'b000;
                    w_count <= 2'b00;
                end
            end
            2'b01: begin
                w_seq <= {w_seq[1:0], w};
                w_count <= w_count + (w ? 1 : 0);
                if(w_count == 2 && w_seq == 3'b110 || w_seq == 3'b101 || w_seq == 3'b011) begin
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
                if(w_seq == 3'b111 || w_seq == 3'b000 || w_seq == 3'b001 || w_seq == 3'b010 || w_seq == 3'b100) begin
                    state <= 2'b00;
                    w_seq <= 3'b000;
                    w_count <= 2'b00;
                end
            end
        endcase
    end
end

endmodule