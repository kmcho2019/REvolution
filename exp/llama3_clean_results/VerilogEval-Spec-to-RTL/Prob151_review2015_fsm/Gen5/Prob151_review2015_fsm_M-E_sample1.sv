module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Pattern Detection Block
reg [3:0] pattern_det;
reg start;

always @(posedge clk) begin
    if (reset) begin
        pattern_det <= 4'b0000;
        start <= 0;
    end
    else begin
        pattern_det <= {pattern_det[2:0], data};
        if (pattern_det == 4'b1101) begin
            start <= 1;
        end
        else begin
            start <= 0;
        end
    end
end

// Counter Control Block
reg [1:0] counter_state;
reg [1:0] counter_count;
reg [3:0] duration;

always @(posedge clk) begin
    if (reset) begin
        counter_state <= 2'b00;
        counter_count <= 2'b00;
        duration <= 4'b0000;
    end
    else begin
        case (counter_state)
            2'b00: begin
                if (start) begin
                    counter_state <= 2'b01;
                    counter_count <= 2'b00;
                end
            end
            2'b01: begin
                shift_ena <= 1;
                duration <= {duration[2:0], data};
                counter_count <= counter_count + 1;
                if (counter_count == 2'b11) begin
                    counter_state <= 2'b10;
                    counter_count <= 2'b00;
                    shift_ena <= 0;
                end
            end
            2'b10: begin
                counting <= 1;
                if (done_counting) begin
                    counter_state <= 2'b11;
                end
            end
            2'b11: begin
                counting <= 0;
            end
        endcase
    end
end

// Acknowledgement Handling Block
reg [1:0] ack_state;

always @(posedge clk) begin
    if (reset) begin
        ack_state <= 2'b00;
    end
    else begin
        case (ack_state)
            2'b00: begin
                if (counter_state == 2'b11) begin
                    ack_state <= 2'b01;
                    done <= 1;
                end
            end
            2'b01: begin
                if (ack) begin
                    ack_state <= 2'b00;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule