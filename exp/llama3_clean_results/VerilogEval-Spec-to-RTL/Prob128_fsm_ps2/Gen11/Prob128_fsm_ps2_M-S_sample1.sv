module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output logic    done
);

enum logic [1:0] {IDLE, COUNTING} state;
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
                    done <= 1'b1;
                    state <= IDLE;
                    byte_count <= 2'b00;
                end
                else begin
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule