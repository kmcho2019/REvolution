module TopModule (
  input clk,
  input areset,
  input train_valid,
  input train_taken,
  output logic [1:0] state
);

  typedef enum logic [1:0] {
    S_NOT_TAKEN,
    S_WEAKLY_NOT_TAKEN,
    S_TAKEN,
    S_STRONGLY_TAKEN
  } state_t;
  
  state_t current_state, next_state;

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= S_WEAKLY_NOT_TAKEN;
    end
    else begin
      current_state <= next_state;
    end
  end

  always_comb begin
    case (current_state)
      S_NOT_TAKEN:
        if (train_valid && train_taken)
          next_state = S_WEAKLY_NOT_TAKEN;
        else if (train_valid && !train_taken)
          next_state = S_NOT_TAKEN;
        else
          next_state = S_NOT_TAKEN;
      S_WEAKLY_NOT_TAKEN:
        if (train_valid && train_taken)
          next_state = S_TAKEN;
        else if (train_valid && !train_taken)
          next_state = S_NOT_TAKEN;
        else
          next_state = S_WEAKLY_NOT_TAKEN;
      S_TAKEN:
        if (train_valid && train_taken)
          next_state = S_STRONGLY_TAKEN;
        else if (train_valid && !train_taken)
          next_state = S_WEAKLY_NOT_TAKEN;
        else
          next_state = S_TAKEN;
      S_STRONGLY_TAKEN:
        if (train_valid && train_taken)
          next_state = S_STRONGLY_TAKEN;
        else if (train_valid && !train_taken)
          next_state = S_TAKEN;
        else
          next_state = S_STRONGLY_TAKEN;
      default:
        next_state = S_WEAKLY_NOT_TAKEN;
    endcase
  end

  always_comb begin
    case (current_state)
      S_NOT_TAKEN: state = 2'b00;
      S_WEAKLY_NOT_TAKEN: state = 2'b01;
      S_TAKEN: state = 2'b10;
      S_STRONGLY_TAKEN: state = 2'b11;
      default: state = 2'b01;
    endcase
  end

endmodule