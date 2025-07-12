module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

reg [2:0] state; // 0: Idle, 1: Receiving, 2: Stop
reg [3:0] data_bit_count;
reg [7:0] data;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0;
        data_bit_count <= 0;
        done <= 0;
    end else begin
        case(state)
            0: begin // Idle
                if(!in) begin
                    state <= 1;
                    data_bit_count <= 0;
                end
            end
            1: begin // Receiving
                data_bit_count <= data_bit_count + 1;
                data <= {data[6:0], in};
                if(data_bit_count == 8) begin
                    state <= 2;
                end
            end
            2: begin // Stop
                if(in) begin
                    done <= 1;
                    state <= 0;
                end else begin
                    state <= 1; // Wait for stop bit
                    data_bit_count <= 0;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if(!done) begin
        done <= 0;
    end
end

endmodule