module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [1:0] state;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
    end
    else begin
        case(state)
            2'b00: begin
                if(in[3]) state <= 2'b01;
            end
            2'b01: state <= 2'b10;
            2'b10: state <= 2'b00;
        endcase
    end
end

assign done = (state == 2'b10);
endmodule