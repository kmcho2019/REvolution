module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

logic [1:0] state;
logic [1:0] next_state;
logic [1:0] count;
logic [1:0] next_count;
logic done_reg;

always_comb begin
    next_state = state;
    next_count = count;
    done_reg = 1'b0;

    case(state)
        2'b00: begin // IDLE
            if(in[3]) begin
                next_state = 2'b01; // BYTE1
                next_count = 1'b1;
            end
        end
        2'b01: begin // BYTE1
            next_count = count + 1'b1;
            if(next_count == 3'b10) begin
                next_state = 2'b00; // IDLE
                done_reg = 1'b1;
            end
        end
        default: begin
            next_count = count + 1'b1;
            if(next_count == 3'b10) begin
                next_state = 2'b00; // IDLE
                done_reg = 1'b1;
            end
        end
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
        count <= 1'b0;
    end
    else begin
        state <= next_state;
        count <= next_count;
    end
end

assign done = done_reg;

endmodule