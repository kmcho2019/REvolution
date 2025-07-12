module traffic_light (
    input  logic rst_n,
    input  logic clk,
    input  logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Enumerations for states
enum logic [1:0] {
    idle = 2'b00,
    s1_red = 2'b01,
    s2_yellow = 2'b10,
    s3_green = 2'b11
} state, next_state;

// Registers
logic [7:0] cnt;
logic p_red, p_yellow, p_green;

// State transition logic
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 0;
        p_yellow <= 0;
        p_green <= 0;
    end else begin
        state <= next_state;
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
    end
end

always_comb begin
    next_state = state;
    case (state)
        idle: next_state = s1_red;
        s1_red: if (cnt == 0) next_state = s3_green;
        s2_yellow: if (cnt == 0) next_state = s1_red;
        s3_green: if (cnt == 0) next_state = s2_yellow;
    endcase
end

// Counting logic
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else if (pass_request && green && cnt > 10) begin
        cnt <= 10;
    end else if (!green && p_green) begin
        cnt <= 60;
    end else if (!yellow && p_yellow) begin
        cnt <= 5;
    end else if (!red && p_red) begin
        cnt <= 10;
    end else begin
        cnt <= cnt - 1;
    end
end

// Output signals
always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            idle: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
            s1_red: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            s2_yellow: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            s3_green: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
        endcase
    end
end

// Assign statement
assign clock = cnt;

endmodule