module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output [7:0] dout_parallel,
    output dout_valid
);

reg [7:0] dout_parallel_reg;
reg [7:0] reg_file; // combined counter and shift register
reg dout_valid_reg;

localparam IDLE = 3'd0;
localparam CONVERTING = 3'd1;
localparam DONE = 3'd2;

// one-hot encoded FSM
reg [2:0] state_reg;
localparam IDLE_STATE = 3'd1;
localparam CONVERTING_STATE = 3'd2;
localparam DONE_STATE = 3'd4;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state_reg <= IDLE_STATE;
        reg_file <= 8'd0;
        dout_valid_reg <= 1'd0;
        dout_parallel_reg <= 8'd0;
    end else begin
        case (state_reg)
            IDLE_STATE: begin
                if (din_valid) begin
                    state_reg <= CONVERTING_STATE;
                    reg_file <= {din_serial, 7'd0};
                end else begin
                    state_reg <= IDLE_STATE;
                end
            end
            CONVERTING_STATE: begin
                if (din_valid) begin
                    // Gray counter implementation
                    if (reg_file[2:0] == 3'd0) begin
                        reg_file[2:0] <= 3'd1;
                    end else if (reg_file[2:0] == 3'd1) begin
                        reg_file[2:0] <= 3'd3;
                    end else if (reg_file[2:0] == 3'd3) begin
                        reg_file[2:0] <= 3'd2;
                    end else if (reg_file[2:0] == 3'd2) begin
                        reg_file[2:0] <= 3'd6;
                    end else if (reg_file[2:0] == 3'd6) begin
                        reg_file[2:0] <= 3'd7;
                    end else if (reg_file[2:0] == 3'd7) begin
                        reg_file[2:0] <= 3'd5;
                    end else if (reg_file[2:0] == 3'd5) begin
                        reg_file[2:0] <= 3'd4;
                    end else if (reg_file[2:0] == 3'd4) begin
                        state_reg <= DONE_STATE;
                    end
                    // shift register implementation
                    reg_file[7:1] <= {din_serial, reg_file[7:2]};
                end else begin
                    state_reg <= IDLE_STATE;
                end
            end
            DONE_STATE: begin
                state_reg <= IDLE_STATE;
                dout_parallel_reg <= reg_file;
                dout_valid_reg <= 1'd1;
            end
        endcase
    end
end

assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule