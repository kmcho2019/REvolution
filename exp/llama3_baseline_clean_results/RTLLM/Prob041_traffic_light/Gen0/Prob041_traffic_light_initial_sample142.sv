module traffic_light (
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Enumerations for different states of the traffic light controller
localparam idle = 2'b00;
localparam s1_red = 2'b01;
localparam s2_yellow = 2'b10;
localparam s3_green = 2'b11;

// Registers for internal counter and state
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// First always block: State transition logic
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: begin
                if (cnt == 0) state <= s3_green;
                else state <= s1_red;
            end
            s2_yellow: begin
                if (cnt == 0) state <= s1_red;
                else state <= s2_yellow;
            end
            s3_green: begin
                if (cnt == 0) state <= s2_yellow;
                else state <= s3_green;
            end
        endcase
    end
end

// Second always block: Counting logic
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 10;
    end else begin
        case (state)
            s1_red: begin
                if (cnt == 0) cnt <= 10;
                else cnt <= cnt - 1;
            end
            s2_yellow: begin
                if (cnt == 0) cnt <= 5;
                else cnt <= cnt - 1;
            end
            s3_green: begin
                if (pass_request && p_green) cnt <= 10;
                else if (!p_green && p_green == 1'b1) cnt <= 60;
                else if (cnt == 0) cnt <= 60;
                else cnt <= cnt - 1;
            end
            default: begin
                cnt <= cnt;
            end
        endcase
    end
end

// Assign statement for output clock
assign clock = cnt;

// Third always block: Output signals
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        case (state)
            idle: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            s1_red: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            s2_yellow: begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            s3_green: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
        endcase
    end
    p_red <= red;
    p_yellow <= yellow;
    p_green <= green;
end

endmodule