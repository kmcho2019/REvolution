module TopModule(
    input           clk,
    input           in,
    input           reset,
    output [7:0]    out_byte,
    output          done
);

reg [7:0] data;
reg [2:0] state;
reg [3:0] counter;
reg       done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;  // IDLE
        counter <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin  // IDLE
                if (~in) begin
                    state <= 1;  // RECEIVE_DATA
                    counter <= 1;
                    data <= {7'b0, in};
                end
            end
            1: begin  // RECEIVE_DATA
                if (counter == 8) begin
                    state <= 2;  // RECEIVE_STOP
                end else begin
                    data <= {data[6:0], in};
                    counter <= counter + 1;
                end
            end
            2: begin  // RECEIVE_STOP
                if (in) begin
                    state <= 0;  // IDLE
                    done_reg <= 1;
                end else begin
                    state <= 3;  // ERROR
                end
            end
            3: begin  // ERROR
                if (in) begin
                    state <= 0;  // IDLE
                end
            end
            default: state <= 0;  // IDLE
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        out_byte <= 8'b0;
        done_reg <= 0;
    end else begin
        if (done_reg) begin
            out_byte <= data;
            done_reg <= 0;
        end
    end
end

assign done = done_reg;

endmodule