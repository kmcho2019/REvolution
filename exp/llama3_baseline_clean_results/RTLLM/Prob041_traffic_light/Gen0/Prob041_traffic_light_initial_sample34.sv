module traffic_light(
    input  logic            rst_n,
    input  logic            clk,
    input  logic            pass_request,
    output logic [7:0]      clock,
    output logic            red,
    output logic            yellow,
    output logic            green
);

// Define the states of the traffic light controller
enum logic [1:0] {
    idle,
    s1_red,
    s2_yellow,
    s3_green
} state, next_state;

// Define the internal counter
logic [7:0] cnt;

// Define the previous values of the output signals
logic p_red, p_yellow, p_green;

// Define the next values of the output signals
logic n_red, n_yellow, n_green;

// First always block: state transition logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        idle: begin
            next_state = s1_red;
        end
        s1_red: begin
            if (cnt == 0) begin
                next_state = s3_green;
            end else begin
                next_state = s1_red;
            end
        end
        s2_yellow: begin
            if (cnt == 0) begin
                next_state = s1_red;
            end else begin
                next_state = s2_yellow;
            end
        end
        s3_green: begin
            if (cnt == 0) begin
                next_state = s2_yellow;
            end else begin
                next_state = s3_green;
            end
        end
        default: begin
            next_state = idle;
        end
    endcase
end

// Second always block: counting logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        if (pass_request && p_green) begin
            cnt <= 10;
        end else if (!p_green && p_green == 1'b1) begin
            cnt <= 60;
        end else if (!p_yellow && p_yellow == 1'b1) begin
            cnt <= 5;
        end else if (!p_red && p_red == 1'b1) begin
            cnt <= 10;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Assign statement: assign the value of the internal counter to the output clock
assign clock = cnt;

// Third always block: output signals
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        case (state)
            idle: begin
                n_red = 0;
                n_yellow = 0;
                n_green = 0;
            end
            s1_red: begin
                n_red = 1;
                n_yellow = 0;
                n_green = 0;
            end
            s2_yellow: begin
                n_red = 0;
                n_yellow = 1;
                n_green = 0;
            end
            s3_green: begin
                n_red = 0;
                n_yellow = 0;
                n_green = 1;
            end
            default: begin
                n_red = 0;
                n_yellow = 0;
                n_green = 0;
            end
        endcase
        p_red = n_red;
        p_yellow = n_yellow;
        p_green = n_green;
        red <= n_red;
        yellow <= n_yellow;
        green <= n_green;
    end
end

endmodule