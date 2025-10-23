module accu (
    input             clk,
    input             rst_n,
    input      [7:0]  data_in,
    input             valid_in,
    output            valid_out,
    output     [9:0]  data_out
);

reg     [9:0]  data_pipe [3:0];
reg             valid_pipe [3:0];
reg     [1:0]  state;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'd0;
        valid_out <= 1'b0;
        data_out <= 10'd0;
        for (int i = 0; i < 4; i++) begin
            data_pipe[i] <= 10'd0;
            valid_pipe[i] <= 1'b0;
        end
    end else begin
        case (state)
            2'd0: begin // Idle state
                if (valid_in) begin
                    data_pipe[0] <= {2'd0, data_in};
                    valid_pipe[0] <= 1'b1;
                    state <= 2'd1;
                end
            end
            2'd1: begin // Accumulation state
                if (valid_pipe[0]) begin
                    data_pipe[1] <= data_pipe[0] + {2'd0, data_in};
                    valid_pipe[1] <= 1'b1;
                    valid_pipe[0] <= 1'b0;
                    state <= 2'd2;
                end
            end
            2'd2: begin // Accumulation state
                if (valid_pipe[1]) begin
                    data_pipe[2] <= data_pipe[1] + {2'd0, data_in};
                    valid_pipe[2] <= 1'b1;
                    valid_pipe[1] <= 1'b0;
                    state <= 2'd3;
                end
            end
            2'd3: begin // Output state
                if (valid_pipe[2]) begin
                    data_pipe[3] <= data_pipe[2] + {2'd0, data_in};
                    valid_out <= 1'b1;
                    data_out <= data_pipe[3];
                    state <= 2'd0;
                    valid_pipe[2] <= 1'b0;
                end
            end
        endcase
    end
end

endmodule