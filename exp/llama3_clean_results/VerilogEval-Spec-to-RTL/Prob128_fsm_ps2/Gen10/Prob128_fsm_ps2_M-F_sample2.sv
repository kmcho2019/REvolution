module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output          done
);

enum logic [1:0] {IDLE, COUNTING, DONE} state;
logic [1:0] byte_count;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        byte_count <= 2'b00;
        done <= 1'b0;
    end
    else begin
        case(state)
            IDLE: begin
                if(in[3]) begin
                    state <= COUNTING;
                    byte_count <= 2'b01;
                end
            end
            COUNTING: begin
                byte_count <= byte_count + 1'b1;
                if(byte_count == 2'b11) begin
                    state <= DONE;
                end
            end
            DONE: begin
                state <= IDLE;
                byte_count <= 2'b00;
            end
        endcase
    end
end

always_comb begin
    if(state == DONE) begin
        done = 1'b1;
    end
    else begin
        done = 1'b0;
    end
end

endmodule