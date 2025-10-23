module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Enumerations for states
localparam idle = 2'b00;
localparam s1_red = 2'b01;
localparam s2_yellow = 2'b10;
localparam s3_green = 2'b11;

// Registers and wires
logic [7:0] cnt;
logic [1:0] state;
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        case (state)
            idle: begin
                state <= s1_red;
                p_red <= 1;
                p_yellow <= 0;
                p_green <= 0;
            end
            s1_red: begin
                if (cnt == 0) begin
                    state <= s3_green;
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 1;
                end else begin
                    p_red <= 1;
                    p_yellow <= 0;
                    p_green <= 0;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    state <= s1_red;
                    p_red <= 1;
                    p_yellow <= 0;
                    p_green <= 0;
                end else begin
                    p_red <= 0;
                    p_yellow <= 1;
                    p_green <= 0;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    state <= s2_yellow;
                    p_red <= 0;
                    p_yellow <= 1;
                    p_green <= 0;
                end else if (pass_request && (cnt > 10)) begin
                    cnt <= 10;
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 1;
                end else begin
                    p_red <= 0;
                    p_yellow <= 0;
                    p_green <= 1;
                end
            end
        endcase
    end
end

// Counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            s1_red: begin
                if (cnt == 0) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    cnt <= 5;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            s3_green: begin
                if (cnt == 0) begin
                    cnt <= 60;
                end else if (pass_request && (cnt > 10)) begin
                    cnt <= 10;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

// Output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        red <= p_red;
        yellow <= p_yellow;
        green <= p_green;
    end
end

assign clock = cnt;

endmodule