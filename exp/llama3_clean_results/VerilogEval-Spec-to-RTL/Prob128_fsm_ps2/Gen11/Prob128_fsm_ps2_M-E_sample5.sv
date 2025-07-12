module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [1:0] state;
logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
        byte_count <= 2'b00;
    end
    else begin
        case(state)
            2'b00: begin // IDLE
                if(in[3]) begin
                    state <= 2'b01;
                    byte_count <= 2'b01;
                end
            end
            2'b01: begin // COUNTING
                byte_count <= byte_count + 1'b1;
                if(byte_count == 3) begin
                    byte_count <= 2'b00;
                    state <= 2'b00;
                end
            end
        endcase
    end
end

always_comb begin
    if(byte_count == 3) begin
        done = 1'b1;
    end
    else begin
        done = 1'b0;
    end
end

endmodule