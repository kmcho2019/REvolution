module traffic_light(
    input logic rst_n,
    input logic clk,
    input logic pass_request,
    output logic [7:0] clock,
    output logic red,
    output logic yellow,
    output logic green
);

// Define the states of the traffic light controller
parameter idle = 2'b00;
parameter s1_red = 2'b01;
parameter s2_yellow = 2'b10;
parameter s3_green = 2'b11;

// Declare the registers and wires
reg [7:0] cnt;
reg [1:0] state;
reg p_red, p_yellow, p_green;

// First always block: state transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= idle;
        p_red <= 1'b0;
        p_yellow <= 1'b0;
        p_green <= 1'b0;
    end else begin
        case (state)
            idle: state <= s1_red;
            s1_red: if (cnt == 0) state <= s3_green;
            s2_yellow: if (cnt == 0) state <= s1_red;
            s3_green: if (cnt == 0) state <= s2_yellow;
            default: state <= idle;
        endcase
    end
end

// Second always block: counting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 8'd10;
    end else begin
        if (pass_request && p_green) begin
            cnt <= 8'd10;
        end else if (!p_green && p_green == 1'b1) begin
            cnt <= 8'd60;
        end else if (!p_yellow && p_yellow == 1'b1) begin
            cnt <= 8'd5;
        end else if (!p_red && p_red == 1'b1) begin
            cnt <= 8'd10;
        end else begin
            if (cnt > 0) begin
                cnt <= cnt - 1;
            end else begin
                cnt <= 0;
            end
        end
    end
end

// Assign the output signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        p_red <= red;
        p_yellow <= yellow;
        p_green <= green;
        case (state)
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
            default: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b0;
            end
        endcase
    end
end

// Assign the value of the internal counter to the output clock
assign clock = cnt;

endmodule